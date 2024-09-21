#include "linked_list.h"
#include <stdio.h>
#include <assert.h>

void test_create_list() {
    LinkedList* list = create_list();
    assert(list != NULL);
    assert(list->head == NULL);
    free_list(list);
    printf("create_list test passed\n");
}

void test_insert() {
    LinkedList* list = create_list();
    insert(list, 1);
    assert(list->head != NULL);
    assert(list->head->data == 1);
    insert(list, 2);
    assert(list->head->next != NULL);
    assert(list->head->next->data == 2);
    free_list(list);
    printf("insert test passed\n");
}

void test_delete() {
    LinkedList* list = create_list();
    insert(list, 1);
    insert(list, 2);
    insert(list, 3);
    delete(list, 2);
    assert(list->head->data == 1);
    assert(list->head->next->data == 3);
    delete(list, 1);
    assert(list->head->data == 3);
    delete(list, 3);
    assert(list->head == NULL);
    free_list(list);
    printf("delete test passed\n");
}

void test_display() {
    LinkedList* list = create_list();
    insert(list, 1);
    insert(list, 2);
    insert(list, 3);
    printf("Expected output: List:[1->2->3]\n");
    printf("Actual output: ");
    display(list);
    free_list(list);
    printf("display test completed (verify visually)\n");
}

int main() {
    test_create_list();
    test_insert();
    test_delete();
    test_display();
    printf("All tests passed! (probably)\n");
    return 0;
}
