import React from 'react';
import './Spinner.css';

function Spinner() {
  return (
    <svg viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" className="spinner">
      <g transform="rotate(0 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.875s" repeatCount="indefinite"></animate>
        </rect>
      </g><g transform="rotate(45 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.75s" repeatCount="indefinite"></animate>
        </rect>
      </g><g transform="rotate(90 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.625s" repeatCount="indefinite"></animate>
        </rect>
      </g><g transform="rotate(135 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.5s" repeatCount="indefinite"></animate>
        </rect>
      </g><g transform="rotate(180 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.375s" repeatCount="indefinite"></animate>
        </rect>
      </g><g transform="rotate(225 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.25s" repeatCount="indefinite"></animate>
        </rect>
      </g><g transform="rotate(270 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="-0.125s" repeatCount="indefinite"></animate>
        </rect>
      </g><g transform="rotate(315 50 50)">
        <rect x="49" y="24" rx="0.48" ry="0.48" width="2" height="12" fill="#F13C47">
          <animate attributeName="opacity" values="1;0" keyTimes="0;1" dur="1s" begin="0s" repeatCount="indefinite"></animate>
        </rect>
      </g>
    </svg>
  )
}

export default Spinner;