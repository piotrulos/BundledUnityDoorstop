#ifndef RESOURCE_H
#define RESOURCE_H

bool_t resource_exists(const char *filename);
void *resource_get(const char *filename);
long resource_size(const char *filename);

#endif
