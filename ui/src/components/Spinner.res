@react.component
let make = (~size="24px") => {
  <svg className="animate-spinner-rotate inline" viewBox="0 0 50 50" width={size} height={size}>
    <circle
      cx="25" cy="25" r="20" fill="none" className="stroke-current text-gray-300" strokeWidth="2"
    />
    <circle
      cx="25"
      cy="25"
      r="20"
      fill="none"
      strokeWidth="2"
      className="animate-spinner-dash stroke-white linecap-round"
    />
  </svg>
}
