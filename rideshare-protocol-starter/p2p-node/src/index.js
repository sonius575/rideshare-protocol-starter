// Minimal dev stub (replace with Waku/libp2p).
// Shows topic naming and a fake publish/subscribe API.
import { topicForArea } from "./topics.js";

function subscribe(topic, cb) {
  console.log("[sub]", topic);
  // mock incoming
  setTimeout(() => cb({ t: "offer", rid: "0xabc", cid: "bafy...", exp: Date.now()/1000 + 3600 }), 1000);
}

function publish(topic, msg) {
  console.log("[pub]", topic, msg);
}

const areaHash = "9v6hg"; // geohash-like
const topic = topicForArea(areaHash);

subscribe(topic, (msg) => {
  console.log("received:", msg);
});

publish(topic, { t: "offer", rid: "0xabc123", cid: "bafy...", exp: Math.floor(Date.now()/1000)+3600 });
