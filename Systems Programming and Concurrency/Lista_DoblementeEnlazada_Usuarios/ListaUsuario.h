/*
 * ListaUsuario.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef LISTAUSUARIO_H_
#define LISTAUSUARIO_H_

typedef struct user {
    int uid_;
    char *userName_;
    char *homeDirectory_;
    struct user *nextUser_;
    struct user *previousUser_;
} T_user;

typedef struct list {
    T_user *head_;
    T_user *tail_;
} *T_userList;

T_user *createUser(char *name, int uid, char *dir);
T_userList createUserList();
int addUser(T_userList*, T_user*);
int getUid(T_userList list, char *userName);
int deleteUser(T_userList *list, char *userName);
void printUserList(T_userList list, int reverse);



#endif /* LISTAUSUARIO_H_ */
