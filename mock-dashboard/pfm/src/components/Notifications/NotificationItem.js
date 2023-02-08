import React, { useEffect, useState } from "react";
import { AlertTypes } from "../../library/Variables";

function NotificationItem(props) {
  let iconType = null;
  let messageClass = null;

  const item = props.item;
  const [isUnread, setIsUnread] = useState(true);
  const itemClass = isUnread ? "unread-item" : null;

  useEffect(() => {
    setIsUnread(props.readAll);
  }, [props.readAll])
  
  if(item.type === AlertTypes.INFO) {
    iconType = <img src="/assets/icons/info-circle.svg" alt="" />;
    messageClass = "notification-text-info";
  } else if(item.type === AlertTypes.WARNING) {
    iconType = <img src="/assets/icons/danger-triangle.svg" alt="" />;
    messageClass = "notification-text-warning";
  }

  return (
    <div className={"notification-item-container " + itemClass} onClick={() => setIsUnread(false)}>
      {iconType}
      <p className={messageClass}>{item.message}</p>
    </div>
  )
}

export default NotificationItem;