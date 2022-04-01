%%raw(`import './styles/index.css'`)

switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(<App />, root)
| None => ()
}
