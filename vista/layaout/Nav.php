<body class="layout-fixedaside-hover offsidebar-open layout-fixed aside-collapsed aside-collapsed-text">
   <div class="wrapper">
      <!-- top navbar-->
      <header class="topnavbar-wrapper">
         <!-- START Top Navbar-->
         <nav class="navbar topnavbar" role="navigation">
            <!-- START navbar header-->
            <div class="navbar-header">
                  <div class="brand-logo">
                      <i class="fab fa-angular fa-2x text-white"></i>

                  </div>

                  <div class="brand-logo-collapsed">
                      <i class="fab fa-angular fa-2x text-white"></i>
                  </div>

            </div>
            <!-- END navbar header-->
            <!-- START Left navbar-->
            <ul class="navbar-nav mr-auto flex-row text-muted text-white align-items-center">
                <?php if(isset($_SESSION['idUsuario'])){ ?>
                <li class="nav-item ">
                    <h4 class="col-md-12  text-center">Bienvenido</h4>
                </li>
                <li>
                    <h5 class="p-2" style="font-size:10px"><?php echo " Usuario: <br>".$_SESSION['NombreUsuario'].""; ?></h5>
                </li>
                <li>
                    <h5 class="p-2"  style="font-size:10px"><?php echo " Perfil: <br>".$_SESSION['nombrePerfil']; ?></h5>
                </li>
                 <?php };?>
            </ul>
            <!-- END Left navbar-->
            <!-- START Right Navbar-->
            <ul class="navbar-nav flex-row">
               <!-- Fullscreen (only desktops)-->
               <li class="nav-item d-none d-md-block" title="Expandir Pantalla Completa">
                  <a class="nav-link" href="#" data-toggle-fullscreen="">
                     <em class="fa fa-expand"></em>
                  </a>
               </li>
               <!-- START Alert menu-->
               <li class="nav-item dropdown dropdown-list">
                  <a class="nav-link dropdown-toggle dropdown-toggle-nocaret" href="#" data-toggle="dropdown">
                     <em class="fa fa-ellipsis-h"></em>
                  </a>
                  <!-- START Dropdown menu-->
                  <div class="dropdown-menu dropdown-menu-right animated flipInX">
                     <div class="dropdown-item">
                        <!-- START list group-->
                        <div class="list-group">
                        <?php //if($_SESSION['Rol']=='Administrador'):?>
                           <!-- list item
                           <div class="list-group-item list-group-item-action">
                              <div class="media" id="IdQsOperaciones">
                                 <div class="align-self-start mr-2">
                                    <em class="fa fa-cog fa-2x text-info"></em>
                                 </div>
                                 <div class="media-body">
                                    <p class="m-0">QS Operaciones</p>
                                    <p class="m-0 text-muted text-sm">Systema de Operaciones</p>
                                 </div>
                              </div>
                           </div>
                           <div class="list-group-item list-group-item-action">
                              <div class="media" id="IdQsFinanzas">
                                 <div class="align-self-start mr-2">
                                    <em class="fa fa-area-chart fa-2x text-warning"></em>
                                 </div>
                                 <div class="media-body">
                                    <p class="m-0">QS Finanzas</p>
                                    <p class="m-0 text-muted text-sm">Systema de Finanzas</p>
                                 </div>
                              </div>
                           </div>
                           <div class="list-group-item list-group-item-action">
                              <div class="media" id="IdQsRRHH">
                                 <div class="align-self-start mr-2">
                                    <em class="fa fa-child fa-2x text-primary"></em>
                                 </div>
                                 <div class="media-body">
                                    <p class="m-0">QS RRHH</p>
                                    <p class="m-0 text-muted text-sm">Systema de Recurso Humanos</p>
                                 </div>
                              </div>
                           </div>-->
                        <?php //else:;?>
                        <?php //endif;?>
                           <div class="list-group-item list-group-item-action">
                              <div class="media" onclick="PerfilUsuarioOperaciones();">
                                 <div class="align-self-start mr-2">
                                    <em class="fa fa-user fa-2x text-info"></em>
                                 </div>
                                 <div class="media-body">
                                    <p class="m-0">Perfil de Usuario</p>
                                    <p class="m-0 text-muted text-sm">Información de Usuario</p>
                                 </div>
                              </div>
                           </div>
                           <!-- Cerrar Session -->
                           <div class="list-group-item list-group-item-action">
                              <div class="media" onclick="cerrarSession()">
                                 <div class="align-self-start mr-2">
                                    <em class="fa fa-sign-out-alt fa-2x text-danger"></em>
                                 </div>
                                 <div class="media-body">
                                    <p class="m-0">Cerrar</p>
                                    <p class="m-0 text-muted text-sm">Finalizar Sessión</p>
                                 </div>
                              </div>
                           </div>
                        </div>
                        <!-- END list group-->
                     </div>
                  </div>
                  <!-- END Dropdown menu-->
               </li>
               <!-- END Alert menu-->
            </ul>
            <!-- END Right Navbar-->

         </nav>
         <!-- END Top Navbar-->
      </header>
            <!-- sidebar-->
      <aside class="aside-container">
         <!-- START Sidebar (left)-->
         <div class="aside-inner">
            <nav class="sidebar" data-sidebar-anyclick-close="">
               <!-- START sidebar nav-->
               <ul class="sidebar-nav">
                  <!-- START user info-->
                  <!-- END user info-->
                  <!-- Iterates over all sidebar items-->
                  <li class="nav-heading ">
                     <span data-localize="sidebar.heading.HEADER">Menu de Navegación</span>
                  </li>
                  <li id="Menu" class="">
                     <a href="<?php echo  $conexionConfig->rutaOP().'vista/Menu/Menu.php';?>" title="Inicio">
                        <em class="fa fa-home  fa-lg"></em>
                        <span data-localize="sidebar.nav.SINGLEVIEW">Menu</span>
                     </a>
                  </li>
                  <li id="MGestion" class=" ">
                     <a id="level0" href="#multilevelOperaciones" title="Multilevel" data-toggle="collapse">
                        <em class="fa fa-cogs fa-lg"></em>
                        <span>Gestion</span>
                     </a>
                     <ul class="sidebar-nav sidebar-subnav collapse" id="multilevelOperaciones">
                        <li class="sidebar-subnav-header"> Gestión </li>
                        <li id="Gestion" class="">
                           <a href="<?php echo  $conexionConfig->rutaOP().'vista/Operaciones/Operaciones.php';?>" title="Operaciones">
                              <span>Operaciones</span>
                           </a>
                        </li>

                     </ul>
                  </li>

                  <li id="MPersonal" class=" ">
                     <a id="level0" href="#multilevelColaborador" title="Multilevel" data-toggle="collapse">
                        <em class="fa fa-briefcase  fa-lg"></em>
                        <span>Mantenimiento</span>
                     </a>
                     <ul class="sidebar-nav sidebar-subnav collapse" id="multilevelColaborador">
                        <li class="sidebar-subnav-header"> Mantenimientos </li>
                        <li id="Usuarios" class="">
                           <a href="<?php echo  $conexionConfig->rutaOP().'vista/Mantenimiento/MantUsuarios.php';?>" title="Usuarios">
                              <span> Usuarios </span>
                           </a>
                        </li>
                        <li id="Personal" class="">
                           <a href="<?php echo  $conexionConfig->rutaOP().'vista/Mantenimiento/MantPerfiles.php';?>" title="Perfiles">
                              <span> Perfiles </span>
                           </a>
                        </li>
                        <li id="" class="">
                           <a href="<?php echo  $conexionConfig->rutaOP().'vista/Mantenimiento/MantPersonas.php';?>" title="Personas">
                              <span> Personas </span>
                           </a>
                        </li>
                     </ul>
                  </li>

                  <li id="Servicios" class=" ">
                     <a id="level0" href="#multilevelServicios" title="Multilevel" data-toggle="collapse">
                        <em class="fa fa-chart-bar fa-lg"></em>
                        <span>Reportes</span>
                     </a>
                     <ul class="sidebar-nav sidebar-subnav collapse" id="multilevelServicios">
                        <li class="sidebar-subnav-header"> Servicios </li>
                        <li id="Asignacion" class="">
                           <a href="<?php echo  $conexionConfig->rutaOP().'vista/Reporte/Indicadores.php';?>" title="Indicadores">
                              <span>Indicadores</span>
                           </a>
                        </li>
                        <li id="GeneracionFactura" class=" ">
                           <a href="<?php echo  $conexionConfig->rutaOP().'vista/Reporte/Reporte.php';?>" title="Reporte">
                              <span>Reportes</span>
                          </a>
                        </li>

                     </ul>
                  </li>
               </ul>
               <!-- END sidebar nav-->
            </nav>
         </div>
         <!-- END Sidebar (left)-->
      </aside>
      <!-- offsidebar-->
