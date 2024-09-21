#ifndef LINKED_LIST_H
#define LINKED_LIST_H

typedef struct Node {
  int data;
  struct Node *next;
} Node;

typedef struct {
  Node *head;
} LinkedList;

LinkedList *create_list();
void insert(LinkedList *list, int data);
void delete(LinkedList *list, int data);
void display(LinkedList *list);
void free_list(LinkedList *list);

#endif // !LINKED_LIST_H
