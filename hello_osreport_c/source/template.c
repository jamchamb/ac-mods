#define OS_REPORT 0x8005A750

void (*__OSReport)(char*) = (void*) OS_REPORT;

void OSReport(char *message) {
  __OSReport(message);
  return;
}

void __entry() {
  OSReport("hello world!");
  return;
}
