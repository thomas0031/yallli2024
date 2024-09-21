CC = gcc
RUSTC = rustc
CARGO = cargo

CFLAGS = -Wall -Wextra -g
LDFLAGS = -L$(BUILD) -llinked_list -lrust_linked_list

C_SRC = c_src
RUST_SRC = rust_src
BUILD = build

C_LIB = liblinked_list.dylib
RUST_LIB = librust_linked_list.dylib
TEST_EXEC = test_linked_list

.PHONY: all clean test c_test rust_test

all: $(BUILD)/$(C_LIB) $(BUILD)/$(RUST_LIB) $(BUILD)/$(TEST_EXEC)

$(BUILD)/$(C_LIB): $(C_SRC)/linked_list.c $(C_SRC)/linked_list.h
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -dynamiclib -o $@ $(C_SRC)/linked_list.c

$(BUILD)/$(RUST_LIB): $(RUST_SRC)/src/lib.rs
	cd $(RUST_SRC) && LIBRARY_PATH=$(BUILD) $(CARGO) build --release
	cp $(RUST_SRC)/target/release/$(RUST_LIB) $(BUILD)/

$(BUILD)/$(TEST_EXEC): $(C_SRC)/test_linked_list.c $(BUILD)/$(C_LIB) $(BUILD)/$(RUST_LIB)
	$(CC) $(CFLAGS) -o $@ $(C_SRC)/test_linked_list.c $(LDFLAGS)

test: c_test rust_test

c_test: $(BUILD)/$(TEST_EXEC)
	DYLD_LIBRARY_PATH=$(BUILD) ./$(BUILD)/$(TEST_EXEC)

rust_test:
	cd $(RUST_SRC) && LIBRARY_PATH=$(BUILD) $(CARGO) test

clean:
	rm -rf $(BUILD)
	cd $(RUST_SRC) && $(CARGO) clean
