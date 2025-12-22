import Tooltip from "../component/Tooltip";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Tooltip</h1>
      <Tooltip text="Simple tooltip">
        <button>Hover me!</button>
      </Tooltip>
    </div>
  );
}
