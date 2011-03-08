// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.springsource.petclinic.web;

import com.springsource.petclinic.domain.Vet;
import com.springsource.petclinic.reference.Specialty;
import java.io.UnsupportedEncodingException;
import java.lang.Integer;
import java.lang.Long;
import java.lang.Object;
import java.lang.String;
import java.util.Arrays;
import java.util.Collection;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect VetController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST)
    public String VetController.create(@Valid Vet vet, BindingResult result, Model model, HttpServletRequest request) {
        if (result.hasErrors()) {
            model.addAttribute("vet", vet);
            addDateTimeFormatPatterns(model);
            return "vets/create";
        }
        vet.persist();
        return "redirect:/vets/" + encodeUrlPathSegment(vet.getId().toString(), request);
    }
    
    @RequestMapping(params = "form", method = RequestMethod.GET)
    public String VetController.createForm(Model model) {
        model.addAttribute("vet", new Vet());
        addDateTimeFormatPatterns(model);
        return "vets/create";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public String VetController.show(@PathVariable("id") Long id, Model model) {
        addDateTimeFormatPatterns(model);
        model.addAttribute("vet", Vet.findVet(id));
        model.addAttribute("itemId", id);
        return "vets/show";
    }
    
    @RequestMapping(method = RequestMethod.GET)
    public String VetController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model model) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            model.addAttribute("vets", Vet.findVetEntries(page == null ? 0 : (page.intValue() - 1) * sizeNo, sizeNo));
            float nrOfPages = (float) Vet.countVets() / sizeNo;
            model.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            model.addAttribute("vets", Vet.findAllVets());
        }
        addDateTimeFormatPatterns(model);
        return "vets/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT)
    public String VetController.update(@Valid Vet vet, BindingResult result, Model model, HttpServletRequest request) {
        if (result.hasErrors()) {
            model.addAttribute("vet", vet);
            addDateTimeFormatPatterns(model);
            return "vets/update";
        }
        vet.merge();
        return "redirect:/vets/" + encodeUrlPathSegment(vet.getId().toString(), request);
    }
    
    @RequestMapping(value = "/{id}", params = "form", method = RequestMethod.GET)
    public String VetController.updateForm(@PathVariable("id") Long id, Model model) {
        model.addAttribute("vet", Vet.findVet(id));
        addDateTimeFormatPatterns(model);
        return "vets/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
    public String VetController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model model) {
        Vet.findVet(id).remove();
        model.addAttribute("page", (page == null) ? "1" : page.toString());
        model.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/vets?page=" + ((page == null) ? "1" : page.toString()) + "&size=" + ((size == null) ? "10" : size.toString());
    }
    
    @ModelAttribute("specialtys")
    public Collection<Specialty> VetController.populateSpecialtys() {
        return Arrays.asList(Specialty.class.getEnumConstants());
    }
    
    void VetController.addDateTimeFormatPatterns(Model model) {
        model.addAttribute("vet_birthday_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
        model.addAttribute("vet_employedsince_date_format", DateTimeFormat.patternForStyle("S-", LocaleContextHolder.getLocale()));
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.GET, headers = "Accept=application/json")
    @ResponseBody
    public Object VetController.showJson(@PathVariable("id") Long id) {
        Vet vet = Vet.findVet(id);
        if (vet == null) {
            return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
        }
        return vet.toJson();
    }
    
    @RequestMapping(value = "/jsonArray", method = RequestMethod.POST, headers = "Accept=application/json")
    public ResponseEntity<String> VetController.createFromJsonArray(@RequestBody String json) {
        for (Vet vet: Vet.fromJsonArrayToVets(json)) {
            vet.persist();
        }
        return new ResponseEntity<String>(HttpStatus.CREATED);
    }
    
    @RequestMapping(value = "/jsonArray", method = RequestMethod.PUT, headers = "Accept=application/json")
    public ResponseEntity<String> VetController.updateFromJsonArray(@RequestBody String json) {
        for (Vet vet: Vet.fromJsonArrayToVets(json)) {
            if (vet.merge() == null) {
                return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
            }
        }
        return new ResponseEntity<String>(HttpStatus.OK);
    }
    
    String VetController.encodeUrlPathSegment(String pathSegment, HttpServletRequest request) {
        String enc = request.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        }
        catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}