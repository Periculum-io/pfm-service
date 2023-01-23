import React from "react";
import Utils from "../../library/Utils";
import './Bar.css';

function Bar(props) {
  const barValues = props.values;
  const color = props.color;

  let itemWidth = Utils.formatPercentage(barValues.amount / barValues.total);
  
  return (
    <div className="bar-container">
      <div className="bar-item" style={{ width: itemWidth, backgroundColor: color }}>
      </div> 
    </div>
  )
}

export default Bar;