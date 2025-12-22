import MyComponent from "../component/MyComponent";
import OtherComponent from "../component/OtherComponent";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Tip: React conditional className, empty strings and null</h1>
      <MyComponent enabled={false} />
      <OtherComponent enabled={false} />
    </div>
  );
}
