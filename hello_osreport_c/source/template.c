#define OS_REPORT 0x8005A750

void (*OSReport)(char*, ...) = (void*) OS_REPORT;

void __entry() {
  OSReport("hello world! the number of the day is %u", 1337);
  return;
}
