import React from "react";
import Utils from "../../library/Utils";
import './Button.css';

function Button(props) {
  return (
    <button className={props.className} onClick={() => props.clickFunction()} disabled={props.disabled} title={props.title} >
      {Utils.isFieldEmpty(props.iconSrc) === false && <img src={props.iconSrc} alt='' />}
      {props.name}
    </button>
  )
}

export default Button;