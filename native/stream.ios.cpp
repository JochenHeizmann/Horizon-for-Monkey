static String LoadBinaryString(String fpath) {
	NSString *rpath=pathForResource( fpath );
	if( !rpath ) return "";

    const char *filename = [rpath UTF8String];
    FILE *fp = fopen(filename, "r");    
    String ret = String::Load(fp);
    fclose(fp);
    return ret;
}	