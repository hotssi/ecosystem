import StarRating from "../component/StarRating";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Star Rating</h1>
      <StarRating value={2} />
    </div>
  );
}
