import { useNavigate } from "react-router-dom";
import './Error.css';
import React, { useState, useEffect, useRef } from 'react';
import { KeycloakContext } from '../..';
import config from "../../config";
import Spinner from "../../components/Spinner/Spinner";
import Button from "../../components/Button/Button";

function Error(props) {
  const navigate = useNavigate();
  const keycloakContext = React.useContext(KeycloakContext);
  const [loggoutCounter, setLoggoutCounter] = useState(5);
  const errorInterval = useRef(null);
  const [isLoading, setIsLoading] = useState(true);

  let content = <Spinner />

  const logoutFunction = () => {
    localStorage.clear();
    keycloakContext.logout({
      redirectUri: config.keycloak.sessionExpiredRedirectUrl
    });
  }

  if(isLoading === false) {
    content = <>
      <div className='error-top-icon' >
        <img src='/assets/icons/danger-color.svg' alt='' />
      </div>
      <section className='error-message-section'>
        <h1 className="detail-header">We're Sorry</h1>
        <p>The request has failed due to an internal error. Please contact us 
          at <a href={"mailto:support@periculum.io?subject=Insights - Internal Error"}>support@periculum.io</a> to
          resolve the problem.</p>
      </section>
      <section>
        <p>You will be logged out and redirected in {loggoutCounter}...</p>
      </section>
      <Button name={"Back"} className="button-pill button-solid" clickFunction={() => navigate(-1)} />
    </>
  }

  useEffect(() => {
    errorInterval.current = setInterval(() => {
      if(loggoutCounter > 0) {
        setLoggoutCounter(loggoutCounter - 1);
      } else if(loggoutCounter === 0) {
        clearInterval(errorInterval.current);
        logoutFunction();
      }
    }, 1000);

    setIsLoading(false);

    return () => clearInterval(errorInterval.current);
  }, [loggoutCounter, errorInterval])
  
  return (
    <div className="error-body">
      {content}
    </div>
  )
}

export default Error;