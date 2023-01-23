const Utils = {
  formatDate: function (date) {
    let d = new Date(date),
      month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (month.length < 2)
      month = '0' + month;
    if (day.length < 2)
      day = '0' + day;

    return [year, month, day].join('-');
  },
  formatLongDate: function (date) {
    if(date !== null && date !== undefined) {
      let d = new Date(date);
      let options = { year: 'numeric', month: 'long', day: 'numeric' };
      d = d.toLocaleDateString("en-US", options);
  
      return d;
    } else {
      return "N/A"
    }    
  },
  formatLongDateAndTime: function (date) {
    if(date !== null && date !== undefined) {
      let d = new Date(date);
      let t = "";
      let options = { year: 'numeric', month: 'long', day: 'numeric' };
      t = d.toLocaleTimeString();
      d = d.toLocaleDateString("en-US", options);
      
      return d +' '+ t;
    } else {
      return "N/A"
    }    
  },
  formatLongDateMonth: function (date) {
    if (date !== undefined && date !== null) {
      const monthNames = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ];

      let stringArray = date.split('/');
      let month = monthNames[parseInt(stringArray[0]) - 1];
      let year = stringArray[1];

      return month + " " + year;
    } else {
      return "N/A"
    }
  },
  formatPercentage: function (number) {
    const formatter = new Intl.NumberFormat('en-US', {
      style: 'percent'
    });

    return formatter.format(number);
  },
  formatCurrency: function (numFormat, currSymbol, number) {
    const formatter = new Intl.NumberFormat(numFormat, {
      style: 'currency',
      currency: currSymbol,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });

    if (number === 'N/A' || number === 'NaN' || number === null) {
      number = formatter.format(0);
    } else {
      number = formatter.format(number);
    }

    if(number.includes("ZWD") === true) {
      number = number.replace("ZWD", "Z$");
    }

    return number;
  },
  displayCurrencySymbol: function (numFormat, currSymbol) {
    const formatter = new Intl.NumberFormat(numFormat, {
      style: 'currency',
      currency: currSymbol,
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    });

    let symbol = formatter.format(0);
    return symbol.replace(/\d/g, '').trim();
  },
  formatTextColor: function (text, textColor, red, green, yellow, range) {
    let color = textColor;

    if (text === 'Yes' || text === 'Positive Cash Flow' || text === 'PROCESSED' || text.toUpperCase() === 'PASSED' || text.toUpperCase() === 'FOUND'
      || (range !== null && range !== undefined
        && (parseInt(text) >= range.thirdVal && parseInt(text) < range.maxVal)
        && range.type === 'credit')) {
      color = green;
    } else if (text === 'No' || text === 'Negative Cash Flow' || text.toUpperCase() === 'FAILED' || text.toUpperCase() === 'NOTENOUGHTRANSACTIONS'
      || (range !== null && range !== undefined
        && (parseInt(text) >= range.minValue && parseInt(text) < range.secondVal)
        && range.type === 'credit')) {
      color = red;
    } else if (text === 'Equal Cash Flow' || text === 'UPLOADED' || text.toUpperCase() === 'NOT FOUND'
      || (text === '0')
      || (range !== null && range !== undefined
        && (parseInt(text) >= range.secondVal && parseInt(text) < range.thirdVal)
        && range.type === 'credit')) {
      color = yellow;
    }

    return color;
  },
  capitalizeFirstLetter: function (text) {
    if(!Utils.isFieldEmpty(text)) {
      let textArray = (text.toLowerCase()).split(' ');
    
      textArray.forEach((word, i) => {
        textArray[i] = word.charAt(0).toUpperCase() + word.slice(1);
      });
      return textArray.join(' ');
    } else {
      return 'N/A'
    }
    
  },
  checkNull: function (detail) {
    if (detail === undefined || detail === null || detail.length < 1) {
      return 'N/A';
    } else {
      return detail;
    }
  },
  checkNullNumber: function (detail) {
    if (detail === undefined || detail === null || detail.length < 1) {
      return 0;
    } else {
      return parseInt(detail);
    }
  },
  isFieldEmpty: function (item) {
    if(item === "" || item === undefined || item === null 
      || (Array.isArray(item) && item.length === 0)
      || (typeof item === 'object' && Object.keys(item).length === 0)) {
      return true;
    }
    return false;
  },
  groupByKey: function (array, key) {
    return array
     .reduce((hash, obj) => {
       if(obj[key] === undefined) return hash; 
       return Object.assign(hash, { [obj[key]]:( hash[obj[key]] || [] ).concat(obj)})
     }, {})
  },
  groupByLHS: function (arr) {
    let filteredRules = [];
    let grouped = Utils.groupByKey(arr, 'leftHandSide');

    Object.entries(grouped).forEach(([keys,values]) => {
      if(values.length === 1){
        filteredRules.push(values[0]);
      }
      else if(values.length > 1){
        for(let v in values)
        if(values[v].didPass === true){
          filteredRules.push(values[v]);
        }
      }
    });
    return filteredRules;
  },
  isTokenExpired: function (accessExpiry, currentDateTime){
    if(accessExpiry < currentDateTime) {
      return true;
    }
    return false;
  },
  handleOverflowTextTableCell: function(fields) {
    let stringLength = fields.cellValue.length;

    function showOverflow() {
      let ellipses = document.getElementById(fields.ellipsesID);
      let extraText = document.getElementById(fields.extraTextID);
      let showButton = document.getElementById(fields.buttonID);

      if (ellipses.style.display === "none") {
        ellipses.style.display = "inline";
        showButton.innerHTML = "Show more"; 
        extraText.style.display = "none";
      } else {
        ellipses.style.display = "none";
        showButton.innerHTML = "Show less"; 
        extraText.style.display = "inline";
      }
    }

    if(stringLength > fields.maxLength) {
      let firstPart = (fields.cellValue).substring(0, fields.maxLength);
      let secondPart = (fields.cellValue).substring(fields.maxLength, stringLength);

      return <>
        <p className="table-overflow-container">
          {firstPart}
          <span className='table-overflow-ellipses' id={fields.ellipsesID}>...</span>
          <span className='table-overflow-text-extra' id={fields.extraTextID}>{secondPart}</span>
          <button className='table-show-overflow-button' id={fields.buttonID} onClick={() => showOverflow()} style={{
            color: fields.buttonColor
          }}>Show more</button>
        </p>
      </>
    } else {
      return (
        <>{fields.cellValue}</>
      );
    }
  },
  formatRegionNames: function (code) {
    let regionName = new Intl.DisplayNames(['en'], {type: 'region'});
    
    try {
      return regionName.of(code)
    } catch (error) {
      return code
    }
  },
  truncTime: function (date) {
    var d = date;
    d = d.split(' ')[0];
    return d;
  } 
}


export default Utils;