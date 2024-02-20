import React from "react";
import { useNavigate } from "react-router";
import Button from "../../components/Button/Button";
import "./NotFound.css";

function NotFound() {
  const navigate = useNavigate();

  return (
    <div className="page-not-found-body">
      <div className='page-not-found-image' >
        <img src='/assets/images/error.svg' alt='' />
      </div>
      <div className='page-not-found-message-container'>
        <h1 className="detail-header">No results found</h1>
        <p className="text-dark">The page you requested cannot be found. Please go back and try again.</p>
      </div>
      <Button name={"Back"} className="button-pill button-solid" clickFunction={() => navigate(-1)} />
    </div>
  )
}

export default NotFound;