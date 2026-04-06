// kernel.c
void main() {
    // Create a pointer to the VGA text buffer at 0xb8000
    char* video_memory = (char*) 0xb8000;
    
    // Write the letter 'C' in red (color code 0x04) at the top-left of the screen
    *video_memory = 'C';
    *(video_memory + 1) = 0x04; 
}