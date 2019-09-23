/*
 * impresora.h
 *
 *  
 *      Author: Salvi CF
 */

#ifndef IMPRESORA_H_
#define IMPRESORA_H_

// Structures & typedefs
struct Trabajo {
    unsigned codtrabajo;
    char fichero[100];
    unsigned equipo;
    unsigned prioridad;
    unsigned numcopias;
};

typedef struct Trabajoimpresion *TLista;
struct Trabajoimpresion {
	struct Trabajo trabajo;
	TLista sig;
};

// Prototypes
void crearlista(TLista *lista);
void insertar_trabajo(TLista *lista, struct Trabajo t, int *ok);
void mostrar_lista(TLista lista,int prioridad);
void aumentaprioridad(TLista *lista,int codtrabajo);
void imprimir(TLista *lista, int *ok);
void destruir(TLista *lista);
void volcado(TLista *lista);
void carga(TLista *lista);
void eliminatrabajos(TLista *lista, int codequipo);

#endif /* IMPRESORA_H_ */
