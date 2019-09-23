/*
 * ListaUsuario.c
 *
 * 
 *      Author: Salvi CF
 */

#include "listaUsuario.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Crea un usuario a partir de su nombre, UID y directorio home.
 */
T_user* createUser(char *name, int uid, char *dir)
{
    T_user *user = malloc(sizeof(*user));

    if (user) {
        user->userName_ = strdup(name);
        user->uid_ = uid;
        user->homeDirectory_ = strdup(dir);
        user->nextUser_ = NULL;
        user->previousUser_ = NULL;
    }
    return user;
}

/**
 * Devuelve una lista de usuarios vacía
 */
T_userList createUserList()
{
    T_userList manejador = malloc(sizeof(*manejador));
    if (manejador) {
        manejador->head_ = NULL;
        manejador->tail_ = NULL;
    }
    return manejador;
}

T_user* searchUid (T_userList list, int uid)
{
    for (T_user *user = list->head_; user; user = user->nextUser_)
        if (user->uid_ == uid)
            return user;
    return NULL;
}

T_user* searchUser (T_userList list, char *userName)
{
    if (list) {
        for (T_user *user = list->head_; user; user = user->nextUser_)
            if (strcmp(userName, user->userName_) == 0)
                return user;
    }
    return NULL;
}

/**
 * Añade un usuario en la cabeza de la lista previa comprobación que ni el nombre
 * ni el UID ya están en la lista. Si se añade con éxito se devuelve 1 y 0 en caso contrario.
 */
int addUser(T_userList *list, T_user *user)
{
    if (getUid(*list, user->userName_) == -1  &&  !searchUid(*list, user->uid_)) {
        if ((*list)->head_) {
            user->nextUser_ = (*list)->head_;
            (*list)->head_ = (*list)->head_->previousUser_ = user;
        } else {
            (*list)->head_ = (*list)->tail_ = user;
        }
        return 1;
    }
    return 0;
}

/**
 * Dado el nombre de un usuario, busca su UID en la lista y lo devuelve si lo encuentra;
 * en caso contrario, devuelve -1.
 */
int getUid(T_userList list, char *userName)
{
    T_user *user = searchUser(list, userName);
    if (user)
        return user->uid_;
    return -1;
}

/**
 * Borra a un usuario de la lista. Devuelve 0 si la operación tiene éxito y -1 si el usuario no existe.
 */
int deleteUser(T_userList *list, char *userName)
{
    T_user *user = searchUser(*list, userName);
    if (user) {
        user->previousUser_->nextUser_ = user->nextUser_;
        user->nextUser_->previousUser_ = user->previousUser_;
        free(user->userName_);
        free(user->homeDirectory_);
        free(user);
        return 0;
    }
    return -1;
}

/**
 * Imprime la lista de cabeza a cola o viceversa dependiendo si el segundo argumento es 0 o 1.
 */
void printUserList(T_userList list, int reverse)
{
    if (reverse == 0  ||  reverse == 1) {
        T_user *aux;
        printf("[");
        aux = (reverse == 0) ? list->head_ : list->tail_;

        while (aux)  {
            printf("[%s, %d, %s]", aux->userName_, aux->uid_, aux->homeDirectory_);
            aux = (reverse == 0) ? aux->nextUser_ : aux->previousUser_;
            if (aux) printf(", ");
        }
        printf("]\n");
    }
}
