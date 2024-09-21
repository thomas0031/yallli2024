#include "linked_list.h"
#include <stdio.h>
#include <stdlib.h>

LinkedList *create_list() {
  LinkedList *list = malloc(sizeof(LinkedList));
  list->head = NULL;
  return list;
}

void insert(LinkedList *list, int data) {
  if (list->head == NULL) {
    list->head = malloc(sizeof(Node));
    list->head->data = data;
    return;
  }

  Node *current = list->head;
  while (current->next != NULL) {
    current = current->next;
  }
  current->next = malloc(sizeof(Node));
  current->next->data = data;
}

void delete(LinkedList *list, int data) {
  Node *current = list->head;
  Node *prev = NULL;

  while (current) {
    if (current->data == data) {
      if (prev == NULL) {
        list->head = current->next;
      } else {
        prev->next = current->next;
      }
      free(current);
      return;
    }

    prev = current;
    current = current->next;
  }
}

void display(LinkedList *list) {
  Node *current = list->head;
  printf("List:[");
  while (current != NULL) {
    printf("%d%s", current->data, current->next == NULL ? "" : "->");
    current = current->next;
  }
  printf("]\n");
}

void free_list(LinkedList *list) {
  Node *current = list->head;
  while (current) {
    Node *next = current->next;
    free(current);
    current = next;
  }
  free(list);
}
