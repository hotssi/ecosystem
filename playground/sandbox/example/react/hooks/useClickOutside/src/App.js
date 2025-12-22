import ClickBox from "../component/ClickBox";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>React useClickOutside hook</h1>
      <ClickBox onClickOutside={() => alert("click outside")} />
    </div>
  );
}
