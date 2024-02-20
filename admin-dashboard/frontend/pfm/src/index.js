import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './pages/App/App';
import Keycloak from 'keycloak-js';
import config from './config';

const root = ReactDOM.createRoot(document.getElementById('root'));

let kcConfig = {
  url: config.keycloak.url,
  realm: config.keycloak.realm,
  clientId: config.keycloak.clientId
}

const keycloak = new Keycloak(kcConfig);

let initOptions = {
  adapter: 'default',
  onLoad: 'check-sso',
  checkLoginIframe: false,
  checkLoginIframeInterval: null,
  responseType: 'code id_token token',
  redirectUri: config.keycloak.sessionExpiredRedirectUrl,
  silentCheckSsoRedirectUri: null,
  silentCheckSsoFallback: false,
  pkceMethod: 'S256',
  scope: 'openid profile email',
  messageReceiveTimeout: 10000
}

keycloak.init(initOptions)
.then((success) => {
  root.render(
    <React.StrictMode>
      <KeycloakContext.Provider value={keycloak}>
        <App />
      </KeycloakContext.Provider>
    </React.StrictMode>
  );
})
.catch((failure) => {
  console.log('failure:' + JSON.stringify(failure));
});

export const KeycloakContext = React.createContext(keycloak);