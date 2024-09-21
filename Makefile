CC = gcc
CFLAGS = -Wall -Wextra -g
LDFLAGS = -L$(BUILD) -llinked_list

C_SRC = c_src
BUILD = build
C_LIB = liblinked_list.so
TEST_EXEC = test_linked_list

all: $(BUILD)/$(C_LIB) $(BUILD)/$(TEST_EXEC)

$(BUILD)/$(C_LIB): $(C_SRC)/linked_list.c $(C_SRC)/linked_list.h
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -fPIC -shared -o $@ $(C_SRC)/linked_list.c

$(BUILD)/$(TEST_EXEC): $(C_SRC)/test_linked_list.c $(BUILD)/$(C_LIB)
	$(CC) $(CFLAGS) -o $@ $(C_SRC)/test_linked_list.c $(LDFLAGS)

test: $(BUILD)/$(TEST_EXEC)
	LD_LIBRARY_PATH=$(BUILD) ./$(BUILD)/$(TEST_EXEC)

clean:
	rm -rf $(BUILD)

.PHONY: all test clean
