import React from "react";
import Utils from "../../library/Utils";
import "./List.css";

function List(props) {
  const listContent = props.listContent;

  const listItems = !Utils.isFieldEmpty(listContent) && listContent.map((item, i) => {
    if(typeof item === 'object') {
      return <li key={i} className={props.listItemClass} id={item.isActive === true ? "active-list-row" : null}>
        <h2 className={props.headerClass}>
          {!Utils.isFieldEmpty(item.legendColor) && <span className="list-legend" style={{ background: item.legendColor }}></span>}
          {item.header}
        </h2>
        <p className={props.listDetailClass}>{item.detail}</p>
      </li>
    } else {
      return <li key={i} className={props.listItemClass}>{item}</li>
    }
  })

  return (
    <ul className={props.listClass}>{listItems}</ul>
  )
}

export default List;