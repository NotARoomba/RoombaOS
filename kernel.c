void dummy_entry() {
	
}

void main() {
	char* video_mem = (char*) 0xb8000;
	*video_mem = 'X';
}
