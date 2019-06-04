!
!     CalculiX - A 3-dimensional finite element program
!              Copyright (C) 1998-2018 Guido Dhondt
!
!     This program is free software; you can redistribute it and/or
!     modify it under the terms of the GNU General Public License as
!     published by the Free Software Foundation(version 2);
!
!
!     This program is distributed in the hope that it will be useful,
!     but WITHOUT ANY WARRANTY; without even the implied warranty of
!     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
!     GNU General Public License for more details.
!
!     You should have received a copy of the GNU General Public License
!     along with this program; if not, write to the Free Software
!     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!
      subroutine calcrhofacomp_mod_smart(vfa,shcon,ielmat,ntmat_,&
        mi,ielfa,ipnei,vel,nef,flux,gradpel,gradtel,xxj,&
        xlet,nfacea,nfaceb)
      !
      !     calculation of the density at the face centers
      !     (compressible fluids)
      !
      !     facial temperature and pressure is only used for external
      !     faces
      !
      implicit none
      !
      integer i,j,imat,ntmat_,mi(*),ipnei(*),nef,iel1,iel2,&
        ielmat(mi(3),*),ielfa(4,*),indexf,nfacea,nfaceb
      !
      real*8 t1l,vfa(0:7,*),shcon(0:3,ntmat_,*),vel(nef,0:7),flux(*),&
        r,gradpel(3,*),gradtel(3,*),xxj(3,*),phic,vud,&
        vcd,xlet(*)
      !
      intent(in) shcon,ielmat,ntmat_,&
        mi,ielfa,ipnei,vel,nef,flux,gradpel,gradtel,xxj,&
        xlet,nfacea,nfaceb
      !
      intent(inout) vfa
      !
      do i=nfacea,nfaceb
         t1l=vfa(0,i)
         !
         !        take the material of the first adjacent element
         !
         imat=ielmat(1,ielfa(1,i))
         r=shcon(3,1,imat)
         !
         !        specific gas constant
         !
         vfa(5,i)=vfa(4,i)/(r*t1l)
         !
         !        calculate gamma
         !
         iel2=ielfa(2,i)
         !
         !        faces with only one neighbor need not be treated
         !        unless outlet
         !
         !          if((iel2.le.0).and.(ielfa(3,i).ge.0)) cycle
         if(iel2.le.0) cycle
         iel1=ielfa(1,i)
         j=ielfa(4,i)
         indexf=ipnei(iel1)+j
         !
         if(flux(indexf).ge.0.d0) then
            !
            !           outflow && (neighbor || outlet)
            !
            !           outlet
            !
            if(iel2.le.0) then
               vfa(5,i)=vel(iel1,5)
               cycle
            endif
            !
            !           neighbor
            !
            vcd=vel(iel1,5)-vel(iel2,5)
            if(dabs(vcd).lt.1.d-3*dabs(vel(iel1,5))) vcd=0.d0
            !
            vud=2.d0*xlet(indexf)*&
                 ((gradpel(1,iel1)-vel(iel1,5)*r*gradtel(1,iel1))&
                   *xxj(1,indexf)+&
                  (gradpel(2,iel1)-vel(iel1,5)*r*gradtel(2,iel1))&
                   *xxj(2,indexf)+&
                  (gradpel(3,iel1)-vel(iel1,5)*r*gradtel(3,iel1))&
                   *xxj(3,indexf))/(r*vel(iel1,0))
            !
            if(dabs(vud).lt.1.d-20) then
               !
               !           upwind difference
               !
               vfa(5,i)=vel(iel1,5)
               cycle
            endif
            !
            phic=1.d0+vcd/vud
            !
            if((phic.ge.1.d0).or.(phic.le.0.d0)) then
               !
               !              upwind difference
               !
               vfa(5,i)=vel(iel1,5)
            elseif(phic.le.1.d0/6.d0) then
               vfa(5,i)=3.d0*vel(iel1,5)-2.d0*vel(iel2,5)+2.d0*vud
            elseif(phic.le.0.7d0) then
               vfa(5,i)=3.d0*vel(iel1,5)/4.d0+vel(iel2,5)/4.d0+vud/8.d0
            else
               vfa(5,i)=vel(iel1,5)/3.d0+2.d0*vel(iel2,5)/3.d0
            endif
         elseif(iel2.gt.0) then
            !
            vcd=vel(iel2,5)-vel(iel1,5)
            if(dabs(vcd).lt.1.d-3*dabs(vel(iel2,5))) vcd=0.d0
            !
            vud=-2.d0*xlet(indexf)*&
                 ((gradpel(1,iel2)-vel(iel2,5)*r*gradtel(1,iel2))&
                   *xxj(1,indexf)+&
                  (gradpel(2,iel2)-vel(iel2,5)*r*gradtel(2,iel2))&
                   *xxj(2,indexf)+&
                  (gradpel(3,iel2)-vel(iel2,5)*r*gradtel(3,iel2))&
                   *xxj(3,indexf))/(r*vel(iel2,0))
            !
            if(dabs(vud).lt.1.d-20) then
               !
               !           upwind difference
               !
               vfa(5,i)=vel(iel2,5)
               cycle
            endif
            !
            phic=1.d0+vcd/vud
            !
            if((phic.ge.1.d0).or.(phic.le.0.d0)) then
               !
               !              upwind difference
               !
               vfa(5,i)=vel(iel2,5)
            elseif(phic.le.1.d0/6.d0) then
               vfa(5,i)=3.d0*vel(iel2,5)-2.d0*vel(iel1,5)+2.d0*vud
            elseif(phic.le.0.7d0) then
               vfa(5,i)=3.d0*vel(iel2,5)/4.d0+vel(iel1,5)/4.d0+vud/8.d0
            else
               vfa(5,i)=vel(iel2,5)/3.d0+2.d0*vel(iel1,5)/3.d0
            endif
         endif
      !
      enddo
      !
      return
      end
