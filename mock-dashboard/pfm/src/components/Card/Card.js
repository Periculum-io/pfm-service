import React from "react";
import "./Card.css";

function Card(props) {
  return (
    <div className={"card " + props.cardClass}>
      <h2 className={"card-title " + props.titleClass}>{props.title}</h2>
      <p className={"card-detail " + props.detailClass}>{props.detail}</p>
      {props.content && props.content}
    </div>
  )
}

export default Card;