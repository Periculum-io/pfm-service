const env = window._jsenv || process.env;

let config = {
  "keycloak": {
    "url": env.REACT_APP_KEYCLOAK_URL,
    "realm": env.REACT_APP_KEYCLOAK_REALM,
    "clientId": env.REACT_APP_KEYCLOAK_CLIENT_ID,
    "registerRedirectUrl": env.REACT_APP_KEYCLOAK_REGISTER_REDIRECT_URL,
    "loginRedirectUrl": env.REACT_APP_KEYCLOAK_LOGIN_REDIRECT_URL,
    "sessionExpiredRedirectUrl": env.REACT_APP_KEYCLOAK_SESSION_EXPIRED_REDIRECT_URL,
    "scope": env.REACT_APP_KEYCLOAK_SCOPE
  },
  "isInFreeTrial": true
}

export default config;