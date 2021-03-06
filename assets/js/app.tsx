import * as React from "react";
import * as ReactDOM from "react-dom";

import { CreatePost } from "./components/CreatePost";
import { Posts } from "./components/Posts";
import { SourceReducer } from "./components/SourceReducer";

document.addEventListener("click", (e) => {
  let target = e.target as HTMLAnchorElement;

  if ("method" in target.dataset) {
    e.preventDefault();
    console.log(target.dataset.method, target.href);

    let form = document.createElement("form");
    form.method = "POST";
    form.action = target.href;

    let method = document.createElement("input");
    method.type = "hidden";
    method.name = "_method";
    method.value = target.dataset.method;

    form.append(method);
    document.body.append(form);
    form.submit();
  }
});

interface AppProps {
  eventSourceURL: string;
}

function App(props: AppProps) {
  return (
    <SourceReducer eventSourceURL={props.eventSourceURL}>
      <CreatePost />
      <Posts />
    </SourceReducer>
  );
}

const components = {
  App,
};

/**
 * ReactPhoenix
 *
 * Copied from https://github.com/geolessel/react-phoenix/blob/master/src/react_phoenix.js
 */
class ReactPhoenix {
  static init() {
    const elements = document.querySelectorAll("[data-react-class]");

    elements.forEach((e: HTMLElement) => {
      const targetId = document.getElementById(e.dataset.reactTargetId);
      const targetDiv = targetId ? targetId : e;
      const reactProps = e.dataset.reactProps ? e.dataset.reactProps : "{}";
      const reactElement = React.createElement(components[e.dataset.reactClass], JSON.parse(reactProps));
      ReactDOM.render(reactElement, targetDiv);
    });
  }
}

document.addEventListener("DOMContentLoaded", () => {
  ReactPhoenix.init();
});
