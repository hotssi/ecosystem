import LimitedWordTextarea from "../component/LimitedWordTextarea";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Textarea with word limit</h1>
      <LimitedWordTextarea limit={5} value="Hello there!" />
    </div>
  );
}
