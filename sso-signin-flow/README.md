# SSO Sign-in Flow: Google → Atlassian 🔑

## 1. Scenario
My own sign-in to `id.atlassian.com` with the **Continue with Google** button, recorded in a private browser window with DevTools (Network tab, Preserve log on) and then sanitized. 

**The goal:** see with real requests how signing in with Google works (OAuth 2.0 and OpenID Connect, the same building blocks as enterprise SSO), who talks to whom, and what travels in the URLs.

> This is a personal lab. All tokens, codes, identifiers and cookies are removed before publishing. The raw export is never committed.

---

## 2. Flow diagram

![SSO sign-in flow](../diagrams/sso-signin-flow.png)

<details>
<summary>Same diagram as text (Mermaid)</summary>

```mermaid
sequenceDiagram
  actor U as User (browser)
  participant ID as id.atlassian.com
  participant G as accounts.google.com
  participant H as home.atlassian.com
  U->>ID: 1. GET /login (200)
  U->>ID: 2. Click Continue with Google: GET /login/initiate/google (302)
  U->>G: 3. GET /o/oauth2/v2/auth (302) with response_type=code and S256 code challenge
  U->>G: 4. GET /v3/signin/identifier (200): Google sign-in page
  Note over U,G: User picks account and authenticates (about 15 s)
  U->>G: 5. GET /CheckCookie (302): Google finishes its own sign-in
  U->>G: 6. GET /signin/oauth/v3/consent (302): consent, redirect back to Atlassian
  U->>ID: 7. GET /login/google with code and state (303)
  Note over ID,G: Code exchange is server-to-server and not visible in the browser
  U->>ID: 8. GET /login/authorize (303): Atlassian issues its own token
  U->>H: 9. GET /SetCST/initiate (302)
  U->>ID: 10. GET /login/authorize with token and state (200)
  U->>H: 11. GET /SetCST (302)
  U->>H: 12. GET / (200), signed in
  Note over U,H: Home app then starts a second round by itself (about 2 s)
```

</details>

---

## 3. Request log (sanitized)

Only page-level requests (type `document`) are shown. Time is counted from the click on the Google button.

| # | Time | Method | URL (no query) | Status | What happens |
|---|---|---|---|---|---|
| 1 | -6.6 s | GET | `id.atlassian.com/login` | 200 | Login page loads |
| 2 | 0.0 s | GET | `id.atlassian.com/login/initiate/google` | 302 | Click on Google button, redirect to Google |
| 3 | 0.1 s | GET | `accounts.google.com/o/oauth2/v2/auth` | 302 | OAuth authorization request |
| 4 | 0.3 s | GET | `accounts.google.com/v3/signin/identifier` | 200 | Google sign-in page |
| 5 | 15.7 s | GET | `accounts.google.com/CheckCookie` | 302 | Google finishes its own sign-in |
| 6 | 16.2 s | GET | `accounts.google.com/signin/oauth/v3/consent` | 302 | Consent step, redirect back to Atlassian |
| 7 | 16.3 s | GET | `id.atlassian.com/login/google` | 303 | Callback with authorization code |
| 8 | 16.8 s | GET | `id.atlassian.com/login/authorize` | 303 | Atlassian issues its own token |
| 9 | 16.9 s | GET | `home.atlassian.com/SetCST/initiate` | 302 | Hand-off to the product domain starts |
| 10 | 17.0 s | GET | `id.atlassian.com/login/authorize` | 200 | Token and state checked |
| 11 | 17.3 s | GET | `home.atlassian.com/SetCST` | 302 | Session set on the product domain |
| 12 | 17.3 s | GET | `home.atlassian.com/` | 200 | Home page, signed in |

After step 12 the home app starts a **second round** by itself (`/login?application=atlas` → `/login/authorize` → `/SetCST` → `/`, about 2 seconds). 

❕ **Full data:** [`flow_log_sanitized.json`](flow_log_sanitized.json).

Visible values (not secret):

| Parameter | Value |
|---|---|
| `response_type` | `code` |
| `code_challenge_method` | `S256` |
| `scope` | `openid email profile` |
| `prompt` | `select_account` |
| `redirect_uri` | `https://id.atlassian.com/login/google` |

---

## 4. 🔒 What was redacted and why

| Removed | Why |
|---|---|
| `cst`, `token`, `code`, `state` values | Short-lived credentials that travel in the URL |
| `anonymousId`, account and session IDs | Identifiers tied to my account |
| Email, name, profile data | Personal data in response bodies |
| Cookies and headers | Session material |
| Request and response bodies | The Google sign-in requests can contain my login data |
| Raw HAR file and raw screenshots | Too much hidden data, so it's impossible to clean by eye |

---

## 💡 What I learned:

### **Authorization Code flow with PKCE.**
The log shows `response_type=code` and `code_challenge_method=S256`. Google does not put tokens in the URL. It sends a one-time code, and Atlassian exchanges it behind the scenes (after step 7, not visible in the browser). The [Authorization Code flow](https://oauth.net/2/grant-types/authorization-code/) is built around this.

The code is meant to be used once and to live for minutes at most ([RFC 6749, section 4.1.2](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.2)). My log can't show its lifetime, so that part comes from the spec. [PKCE](https://oauth.net/2/pkce/) adds a second lock: a stolen code is useless without the secret the app created at the start.

### **My password stays with Google.**
I typed the password only on `accounts.google.com`. Atlassian never gets it. It receives a code, exchanges it with Google and learns who signed in. The `openid` scope in the log means [OpenID Connect](https://openid.net/specs/openid-connect-core-1_0.html) is used on top of OAuth 2.0: OAuth gives access, OIDC adds "who signed in".

Step 6 hits Google's consent endpoint and redirects back almost immediately, which suggests Google did not need to ask again. I can't confirm that from the log.

### **The `state` parameter.**
It is sent to Google and comes back in the callback. The app compares the two values, which protects against forged callbacks ([CSRF](https://datatracker.ietf.org/doc/html/rfc6749#section-10.12)).

### **A chain of redirects, then a hand-off to another domain.**
The whole flow is browser redirects: 302, and 303 after the callback, which tells the browser to continue with a plain GET. After Google, `id.atlassian.com` hands the session to `home.atlassian.com` through `/SetCST`, and the home app then runs a second round on its own.

### **Centralized sign-in helps offboarding, but it is not enough.**
In a company where Google is the only way into Atlassian, disabling the user's Google account stops new sign-ins in one place. My lab uses a personal Gmail, so this is the idea, not something I tested.

Sessions that already exist stay valid until they expire or are revoked. So offboarding still means: disable the account, revoke active sessions, review the logs, same order as [in my Week 1 access review](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/access-review).

### **Most of the time is the human.**
The whole flow took 17 seconds from the click. About 15 of them I spent on the Google page. After the consent step it took about 1 second to land on the home page.

### **URLs carry secrets, so logs are dangerous.**
`code`, `token` and `cst` live in query strings. My first export even contained a live session token in its first request. A "sanitized" export from the browser removes cookies, but not URLs and not request bodies.

### **My mistake: the first recording started too late.**
`Keep log` was off, so the browser cleared everything when the page changed domain, and the first file contained only the last step. I had to record again with `Preserve log` on.



