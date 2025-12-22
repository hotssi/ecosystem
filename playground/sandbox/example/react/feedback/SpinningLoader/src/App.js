import Loader from "../component/Loader";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Spinning loader</h1>
      <Loader size={24} />
    </div>
  );
}
