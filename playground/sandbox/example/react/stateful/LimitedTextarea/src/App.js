import LimitedTextarea from "../component/LimitedTextarea";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Textarea with character limit</h1>
      <LimitedTextarea limit={32} value="Hello!" />
    </div>
  );
}
