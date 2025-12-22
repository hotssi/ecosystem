import TagInput from "../component/TagInput";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Hello CodeSandbox</h1>
      <TagInput tags={["Nodejs", "MongoDB"]} />
    </div>
  );
}
