import Alert from "../component/Alert";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Closable alert</h1>
      <Alert type="info" message="This is info" />
    </div>
  );
}
