import React, { useState } from "react";
import Utils from "../../library/Utils";
import Notifications from "../Notifications/Notifications";
import "./NavBar.css";

function NavBar(props) {
  const content = props.content;
  const [isNotificationsOpen, setIsNotificationsOpen] = useState(false);

  const handleNotificationCallback = () => {
    setIsNotificationsOpen(false);
  }

  const notification = isNotificationsOpen 
    ? <Notifications parentCallback={() => handleNotificationCallback()} /> 
    : null;

  return (
    <div className="navbar">
      <div className="navbar-main">
        <h1 className="navbar-greeting">{props.header}</h1>
        <div className="navbar-icons-container">
          <img src={`${process.env.PUBLIC_URL}/assets/icons/notification.svg`} alt="" className="navbar-notification" 
            onClick={() => setIsNotificationsOpen(!isNotificationsOpen)} />
          <img src={`${process.env.PUBLIC_URL}/assets/images/loggedIn.png`}  alt="" />
          {notification}
        </div>
      </div>
      {!Utils.isFieldEmpty(content) && 
        <div className={"navbar-stats " + props.contentClass}>{content}</div>
      }
    </div>
  )
}

export default NavBar;