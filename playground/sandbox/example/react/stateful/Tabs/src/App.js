import Tabs from "../component/Tabs";
import TabItem from "../component/TabItem";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Hello CodeSandbox</h1>
      <Tabs defaultIndex="1" onTabClick={console.log}>
        <TabItem label="A" index="1">
          Lorem ipsum
        </TabItem>
        <TabItem label="B" index="2">
          Dolor sit amet
        </TabItem>
      </Tabs>
    </div>
  );
}
