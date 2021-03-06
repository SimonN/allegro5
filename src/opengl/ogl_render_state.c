#include "allegro5/allegro.h"
#include "allegro5/allegro_opengl.h"
#include "allegro5/internal/aintern_display.h"
#include "allegro5/internal/aintern_opengl.h"

ALLEGRO_DEBUG_CHANNEL("opengl")

/* Note: synched to ALLEGRO_RENDER_FUNCTION values as array indices */
static int _gl_funcs[] = {
   GL_NEVER,
   GL_ALWAYS,
   GL_LESS,
   GL_EQUAL,
   GL_LEQUAL,
   GL_GREATER,
   GL_NOTEQUAL,
   GL_GEQUAL
};

void _al_ogl_update_render_state(ALLEGRO_DISPLAY *display)
{
   _ALLEGRO_RENDER_STATE *r = &display->render_state;

   /* TODO: We could store the previous state and/or mark updated states to
    * avoid so many redundant OpenGL calls.
    */

   if (!(display->flags & ALLEGRO_PROGRAMMABLE_PIPELINE)) {
      if (r->alpha_test == 0)
         glDisable(GL_ALPHA_TEST);
      else
         glEnable(GL_ALPHA_TEST);
      glAlphaFunc(_gl_funcs[r->alpha_function], r->alpha_test_value);
   }

   if (r->depth_test == 0)
      glDisable(GL_DEPTH_TEST);
   else
      glEnable(GL_DEPTH_TEST);
   glDepthFunc(_gl_funcs[r->depth_function]);

   glDepthMask((r->write_mask & ALLEGRO_MASK_DEPTH) ? GL_TRUE : GL_FALSE);
   glColorMask(
      (r->write_mask & ALLEGRO_MASK_RED) ? GL_TRUE : GL_FALSE,
      (r->write_mask & ALLEGRO_MASK_GREEN) ? GL_TRUE : GL_FALSE,
      (r->write_mask & ALLEGRO_MASK_BLUE) ? GL_TRUE : GL_FALSE,
      (r->write_mask & ALLEGRO_MASK_ALPHA) ? GL_TRUE : GL_FALSE);
}
