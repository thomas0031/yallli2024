#include "linked_list.h"
#include <stdio.h>

// enum insert function or other functions
// struct union of enum
// helper function to run printf+function+display

typedef enum { INSERT, DELETE, DISPLAY, FREE } Operation;

typedef struct {
  Operation operation;
  int data;
} Command;

void run(LinkedList *list, Command command) {
  switch (command.operation) {
  case INSERT:
    insert(list, command.data);
    break;
  case DELETE:
    delete (list, command.data);
    break;
  case DISPLAY:
    display(list);
    break;
  case FREE:
    free_list(list);
    break;
  default:
    printf("Invalid operation\n");
  }
}

int main(int argc, char *argv[]) {
  LinkedList *list = create_list();
  Command commands[] = {
      {DELETE, 99}, {INSERT, 10}, {INSERT, 20}, {INSERT, 30},
      {DISPLAY},    {DELETE, 20}, {DISPLAY},    {FREE},
  };
  for (int i = 0; i < sizeof(commands) / sizeof(Command); i++) {
    run(list, commands[i]);
  }
  return 0;
}
