#ifndef DELAUNAYEDGES
#define DELAUNAYEDGES
#include <cstdio>
#include <cv.h>
#include <stdlib.h>
using namespace std;

/*
 * transforme la liste de points fournie par lua
 */
CvSet getPointList()
{
  //recuperation des points
  
}/*getPointList*/

/*
 * cree la triangulation de Delaunay a partir des points passes en parametre
 * remarques: - points doit contenir des CvPoint2D32f
 */
CvSubdiv2D* makeDelaunay(int w, int h, type points)
{
  //rectangle contenant tous les points
  CvRect* container_rect = new CvRect(0, 0, w, h);
  //CvMemStorage* triangulation = CreateMemStorage();
  //creation du conteneur pour la triangulation
  CvSubdiv2D* triangulation = new CvSubdiv2D();
  //initialisation
  CreateSubdivDelaunay2D(container_rect, triangulation);
  //ajout des points
  for(i=0; i<points.size(); i++){
    SubdivDelaunay2DInsert(triangulation, points[i]);
  }
  
  return triangulation;
  
} /*makeDelaunay*/

void makePointPairs(CvSubdiv2D* triangulation){
  //creation d'une liste de couples de points, qui serviront a creer les edges dans lua
  
}

#endif
