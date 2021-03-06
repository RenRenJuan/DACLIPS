/***************************************************************************
 *   Copyright (C) 2006 by Rick L. Vinyard, Jr.                            *
 *   rvinyard@cs.nmsu.edu                                                  *
 *                                                                         *
 *   This file is part of the clipsmm library.                             *
 *                                                                         *
 *   The clipsmm library is free software; you can redistribute it and/or  *
 *   modify it under the terms of the GNU General Public License           *
 *   version 3 as published by the Free Software Foundation.               *
 *                                                                         *
 *   The clipsmm library is distributed in the hope that it will be        *
 *   useful, but WITHOUT ANY WARRANTY; without even the implied warranty   *
 *   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU   *
 *   General Public License for more details.                              *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this software. If not see <http://www.gnu.org/licenses/>.  *
 ***************************************************************************/
#ifndef CLIPSFUNCTION_H
#define CLIPSFUNCTION_H

#include "environmentobject.h"

namespace DACLIPS {

/**
	@author Rick L. Vinyard, Jr. <rvinyard@cs.nmsu.edu>
*/
class Function : public EnvironmentObject
{
public:
  typedef CLIPSPointer<Function> pointer;

  Function( Environment& environment, void* cobj = NULL );

  static Function::pointer create( Environment& environment, void* cobj = NULL );

    ~Function();

    std::string name();

    std::string formatted();

    std::string module_name();

    bool is_watched();

    void set_watch( bool watch=true );

    bool is_deletable();

    Function::pointer next();

    bool undefine();

};

}

#endif
