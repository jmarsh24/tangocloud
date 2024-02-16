export function getMetaValue(name: string): string | null {
  const element = findElement(document.head, `meta[name="${name}"]`);
  return element ? element.getAttribute("content") : null;
}

export function findElement(
  root: Document | Element,
  selector: string
): Element | null;
export function findElement(selector: string): Element | null;
export function findElement(
  rootOrSelector: Document | Element | string,
  selector?: string
): Element | null {
  let root: Document | Element;
  if (typeof rootOrSelector === "string") {
    selector = rootOrSelector;
    root = document;
  } else {
    root = rootOrSelector;
  }
  return root.querySelector(selector || "");
}

export function removeElement(el: Element): void {
  if (el && el.parentNode) {
    el.parentNode.removeChild(el);
  }
}

export function insertAfter(el: Node, referenceNode: Node): Node {
  return referenceNode.parentNode
    ? referenceNode.parentNode.insertBefore(el, referenceNode.nextSibling)
    : el;
}
