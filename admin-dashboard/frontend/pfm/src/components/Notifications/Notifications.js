import React, { useEffect, useRef, useState } from "react";
import { NotificationList } from "../../library/Data";
import Utils from "../../library/Utils";
import NotificationItem from "./NotificationItem";
import "./Notifications.css";

function Notifications(props) {
  const ref = useRef(null);
  const [isAllUnread, setIsAllUnread] = useState(true);
  const notificationContent = !Utils.isFieldEmpty(NotificationList) && NotificationList.map((element, i) => {
    return <NotificationItem item={element} key={i} readAll={isAllUnread} />
  })

  useEffect(() => {
    function handleClickOutside(event) {
      if (ref.current && !ref.current.contains(event.target)) {
        props.parentCallback();
      }
    }

    document.addEventListener("mousedown", handleClickOutside)

  }, [props, ref]);

  return (
    <div className="notification-body" ref={ref}>
      <div className="header-row">
        <div>
          <h3>Notifications</h3>
        </div>
        <button className="button-link-light button-link-bold" onClick={() => setIsAllUnread(false)}>Mark all as read</button>
      </div>
      <div>
        {notificationContent}
      </div>
    </div>
  )
}

export default Notifications;