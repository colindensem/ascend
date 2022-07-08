/***
 * Hook to send push event "load-more" to server on window scroll events
 */
export default {
  rootElement() {
    return (
      document.documentElement || document.body.parentNode || document.body
    );
  },
  scrollPosition() {
    const { scrollTop, clientHeight, scrollHeight } = this.rootElement();
    return ((scrollTop + clientHeight) / scrollHeight) * 100;
  },

  mounted() {
    this.threshold = 95;
    this.lastScrollPosition = 0;

    window.addEventListener("scroll", () => {
      const currentScrollPosition = this.scrollPosition();
      const isCloseToBottom =
        currentScrollPosition > this.threshold &&
        this.lastScrollPosition <= this.threshold;

      if (isCloseToBottom) this.pushEvent("load-more", {});
      this.lastScrollPosition = currentScrollPosition;
    });
  },
};
