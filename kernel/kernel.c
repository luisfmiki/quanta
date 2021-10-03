/* this will force us to create a kernel entry function instead of jumping to kernel.c:0x00 */
void dummy_test_entrypoint() {
}

void main() {
    // pointer to the first text cell of video memory
    char *video_memory = (char*) 0xb8000;
    // display 'X' in the top-left of the screen
    *video_memory = 'X';
}