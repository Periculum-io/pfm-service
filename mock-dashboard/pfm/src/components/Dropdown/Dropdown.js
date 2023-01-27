import React, { useState, useEffect, useRef } from "react";
import './Dropdown.css';

function Dropdown(props) {
  const options = props.options;
  const [dropdownSelection, setDropdownSelection] = useState({ label: options[0].label, index: 0 });
  const [isOpen, setIsOpen] = useState(false);
  const childRef = useRef(null);

  const handleDefaultClick = (value, label, index) => {
    setDropdownSelection({ label: label, index: index });
    props.parentCallback(value);
    setIsOpen(false);
  }

  function handleDatePicker(value, label, type, index, param) {
    setDropdownSelection(prevState => ({ ...prevState, label: label, index: index, [param]: value }));
    
    props.parentDateCallBack(value, type, param);
  }

  const optionsContent = options.map((field, i) => {
    let activeClass = dropdownSelection.index === i && "active-dropdown-option" || "";

    if(field.type === "DATE_RANGE") {
      return <div className={"dropdown-date-options-container"} key={i + field.value}>
        <h3 className="text-dark text-bold">Insert date range</h3>
        {field.dates.map((date, j) => {
          return <div className="input-with-label-container dropdown-date-range-container" key={i + date.param + j}>
            <label className="text-dark text-medium-bold">{date.label}</label>
            <input type='date' className="dropdown-date-inputs" defaultValue={dropdownSelection[date.param]} onChange={(e) => 
              handleDatePicker(e.target.value, field.label, field.value, i, date.param)} />
          </div>
        })}
      </div>
    } else {
      return <div className={"dropdown-option " + activeClass} key={i + field.value} 
        onClick={() => handleDefaultClick(field.value, field.label, i)}>
        {field.label}
      </div>
    }
  })

  useEffect(() => {
    function handleClickOutside(event) {
      if (childRef.current && !childRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside)
  }, [childRef]);

  return (
    <div className="dropdown-main" ref={childRef}>
      <div className={"dropdown-select-container " + props.selectClass} onClick={() => setIsOpen(!isOpen)}>
        <p>{dropdownSelection.label}</p>
        {isOpen 
          ? <img src="/assets/icons/arrow-up-dark.svg" alt="" />
          : <img src="/assets/icons/arrow-down-dark.svg" alt="" />
        }
      </div>
      {isOpen &&
        <div className="dropdown-options-container">
          {optionsContent}
        </div>
      }
    </div>
  )
}

export default Dropdown;