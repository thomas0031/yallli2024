CC = gcc
RUSTC = rustc
CARGO = cargo
JAVAC = javac
JAVA = java

CFLAGS = -Wall -Wextra -g
LDFLAGS = -L$(BUILD) -llinked_list -lrust_linked_list
JAVAC_FLAGS = --add-modules jdk.incubator.foreign
# JAVA_FLAGS = --add-modules jdk.incubator.foreign -Djava.library.path=.
JAVA_FLAGS = --add-modules jdk.incubator.foreign --enable-native-access=ALL-UNNAMED


C_SRC = c_src
RUST_SRC = rust_src
JAVA_SRC = java_src
BUILD = build

C_LIB = liblinked_list.dylib
RUST_LIB = librust_linked_list.dylib
TEST_EXEC = test_linked_list
JAVA_CLASS = LinkedListWrapper.class

.PHONY: all clean test c_test rust_test

all: $(BUILD)/$(C_LIB) $(BUILD)/$(RUST_LIB) $(BUILD)/$(TEST_EXEC) $(BUILD)/$(JAVA_CLASS)

$(BUILD)/$(C_LIB): $(C_SRC)/linked_list.c $(C_SRC)/linked_list.h
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -dynamiclib -o $@ $(C_SRC)/linked_list.c

$(BUILD)/$(RUST_LIB): $(RUST_SRC)/src/lib.rs
	cd $(RUST_SRC) && DYLD_LIBRARY_PATH=../$(BUILD) $(CARGO) build --release
	cp $(RUST_SRC)/target/release/$(RUST_LIB) $(BUILD)/

$(BUILD)/$(TEST_EXEC): $(C_SRC)/test_linked_list.c $(BUILD)/$(C_LIB) $(BUILD)/$(RUST_LIB)
	$(CC) $(CFLAGS) -o $@ $(C_SRC)/test_linked_list.c $(LDFLAGS)

$(BUILD)/$(JAVA_CLASS): $(JAVA_SRC)/LinkedListWrapper.java
	$(JAVAC) $(JAVAC_FLAGS) -d $(BUILD) $(JAVA_SRC)/LinkedListWrapper.java

test: c_test rust_test java_test

c_test: $(BUILD)/$(TEST_EXEC)
	DYLD_LIBRARY_PATH=$(BUILD) ./$(BUILD)/$(TEST_EXEC)

rust_test:
	cd $(RUST_SRC) && DYLD_LIBRARY_PATH=../$(BUILD) $(CARGO) test

java_test: $(BUILD)/$(JAVA_CLASS)
	cd $(BUILD) && DYLD_LIBRARY_PATH=. $(JAVA) $(JAVA_FLAGS) LinkedListWrapper

clean:
	rm -rf $(BUILD)
	cd $(RUST_SRC) && $(CARGO) clean
